Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:56583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761640AbYHEPlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 11:41:23 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2651501rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 08:41:23 -0700 (PDT)
Message-ID: <1ba2fa240808050841o76e324c1od364f6ceb06b687b@mail.gmail.com> (sfid-20080805_174138_330063_E9940B39)
Date: Tue, 5 Aug 2008 18:41:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: one remaining unused CONFIG variable under net/
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217877394.3603.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <alpine.LFD.1.10.0808041508070.11910@localhost.localdomain>
	 <1217877394.3603.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 4, 2008 at 10:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-08-04 at 15:09 -0400, Robert P. J. Day wrote:
>> this is the single remaining CONFIG variable under the net/
>> directory that is currently unreferenced.
>>
>> ===== MAC80211_VERBOSE_SPECT_MGMT_DEBUG
>> net/mac80211/Kconfig:206:config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
>
> Yeah, it'll be used though; it was added in an early patch of the
> spectrum management code, then that got delayed by some confusion over a
> requisite patch and now Tomas wants to redraw that one too... Don't
> worry about it, I'll be keeping an eye on it.
>

Since this won't be included in 2.6.27 we can leave it only wireless-testing.

Tomas
