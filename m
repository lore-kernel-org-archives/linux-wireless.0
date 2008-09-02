Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44623 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYIBWPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 18:15:00 -0400
Received: by gxk9 with SMTP id 9so5679276gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 15:14:58 -0700 (PDT)
Message-ID: <43e72e890809021514w67308d3ar4494e6e67fff3bcd@mail.gmail.com> (sfid-20080903_001505_599362_6C173E68)
Date: Tue, 2 Sep 2008 15:14:58 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [Bugme-new] [Bug 11483] New: Raw socket tx/rx program for "ath0" shows "sending: : No buffer space available"
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	karthikg@deccantechnosoft.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20080902194114.GD3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <bug-11483-10286@http.bugzilla.kernel.org/>
	 <20080902122938.f3858d6d.akpm@linux-foundation.org>
	 <20080902194114.GD3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 2, 2008 at 12:41 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Sep 02, 2008 at 12:29:38PM -0700, Andrew Morton wrote:
>>
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>>
>> I assume this is an atheros driver problem, not a core networking
>> problem..
>
> ath_pci -- looks like madwifi to me...

I see ath_pci but I also see ath9k, and a whole bunch of other
wireless drivers loaded (strange). Anyway though the user reports the
card used is an Ubiquity SR5. These are based on Atheros AR5004
(802.11a) so ath9k cannot be used anyway, this makes it a MadWifi
issue.

  Luis
