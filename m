Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2KFKCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 05:02:18 -0500
Date: Tue, 6 Nov 2012 11:02:13 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121106100213.GA17892@ubuntu-mba51> (sfid-20121106_110234_344917_D6EAFFEC)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <5098B858.7090802@monom.org>
 <5098C7FF.2060308@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5098C7FF.2060308@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2012 at 09:19:11AM +0100, Daniel Wagner wrote:
> On 06.11.2012 08:12, Daniel Wagner wrote:
> >Hi Seth,
> >
> >I am owner of a MBA 2012 and the mainline driver is kind of 'not fun'
> >(read broken). Since a few days I am using it and the situation improved
> 
> it = your patch set on top of 3.7-rc3

Thanks for the report. I'm currently running these patches on top of
3.7-rc3 as well, but I haven't run into this.

I'm at a conference and haven't had time to look at this in depth, but
at a glance I'm not seeing any obvious connection with my changes. If
we're processing a channel switch as suggested by the stack trace then
there aren't any calls back into brcmsmac in this context that I can
find, since brcmsmac isn't providing a channel_switch op. But I'll look
more closely when I get a chance.

Seth
