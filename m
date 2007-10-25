Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:4043 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbXJYKBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 06:01:10 -0400
Received: by rv-out-0910.google.com with SMTP id k20so426823rvb
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2007 03:01:09 -0700 (PDT)
Message-ID: <c85cb4470710250301u28d1b5b9qf7167f629639de8c@mail.gmail.com> (sfid-20071025_110112_991704_168E1E8E)
Date: Thu, 25 Oct 2007 12:01:09 +0200
From: "Ron Rindzonski" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: [RFC] eliminating erp_ie_changed from low level driver ops
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1193227061.4510.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
	 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
	 <1193221337148-git-send-email-ron.rindjunsky@intel.com>
	 <1193227061.4510.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-10-24 at 12:22 +0200, Ron Rindjunsky wrote:
> >                       enum sta_notify_cmd, const u8 *addr);
> > -     void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
> > -                            int cts_protection, int preamble);
>
> you forgot to remove those ERP_CHANGE flags that are passed to changes
> here.
>

will do , thanks

> johannes
>
>
