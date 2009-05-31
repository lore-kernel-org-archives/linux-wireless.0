Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:33248 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZEaG1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 02:27:38 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2336700wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 23:27:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243736227.3623.180.camel@debian>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	<20090526222433.GA23972@bombadil.infradead.org> <1243736227.3623.180.camel@debian>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 30 May 2009 23:27:19 -0700
Message-ID: <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 30, 2009 at 7:17 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Wed, 2009-05-27 at 06:24 +0800, Luis R. Rodriguez wrote:
>> On Thu, May 21, 2009 at 10:18:58AM +0800, Zhu Yi wrote:
>> > The iwmc3200wifi driver
>> > currently supports IEEE 802.11a/b/g (draft N is still working in progress)
>> > in managed and ad-hoc modes.
>>
>> BTW how many streams will this device have?
>
> The current (upcoming) one is an AGN with an SDIO interface. But the
> cores are going to be reused in the future.

Thanks -- yeah I saw some snippets about a possible USB interface.

What is the 11n configuration on these devices? Do they have 2
streams? Or are they just 1 stream?

  Luis
