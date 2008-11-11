Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388AbYKKUOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 15:14:11 -0500
Date: Tue, 11 Nov 2008 12:03:41 -0800
From: Greg KH <greg@kroah.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: stable@kernel.org, rjw@sisk.pl, linville@tuxdriver.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH 0/2] iwlwifi fixes for stable 2.6.27
Message-ID: <20081111200340.GA1784@kroah.com> (sfid-20081111_211416_308764_444D6341)
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com> <20081109041808.GA1017@kroah.com> <1ba2fa240811082313q57cca1fayf94aea9357f52a58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240811082313q57cca1fayf94aea9357f52a58@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 09, 2008 at 09:13:56AM +0200, Tomas Winkler wrote:
> On Sun, Nov 9, 2008 at 6:18 AM, Greg KH <greg@kroah.com> wrote:
> > On Sun, Nov 09, 2008 at 02:51:05AM +0200, Tomas Winkler wrote:
> >> First one didn't make it into the stable due to type in emails
> >> Second is important bug fix that was kept out 2.6.27 merging window.
> >> There is no visible kernel bug but w/o this patch the 5000 iwlwifi HW
> >> is left un-calibrated which is critical
> >
> > Are these already in Linus's tree?  If so, do you have a git commit id
> > for them?
> 
> iwlwifi: fix suspend to RAM in iwlwifi 10d0bd56966571d0324dfd9bbb8aa913a60bef5f
> iwlwifi: generic init calibrations framework
> 6e21f2c109edd746a10e08186484bae8168cdd0c

Thanks, I've now added them, and a few others that were asked for by
other developers.

greg k-h
