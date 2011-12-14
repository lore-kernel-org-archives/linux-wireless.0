Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab1LNQXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 11:23:38 -0500
Date: Wed, 14 Dec 2011 10:23:33 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20111214162333.GB19410@thinkpad-t410> (sfid-20111214_172342_114759_E2AD2951)
References: <4EC88F58.1080203@lwfinger.net>
 <20111121181350.GC6736@thinkpad-t410>
 <4ECA99CC.7020008@lwfinger.net>
 <20111121185610.GD6736@thinkpad-t410>
 <4ECB028E.3030809@lwfinger.net>
 <20111122022008.GA17661@thinkpad-t410>
 <20111213194231.GA30788@thinkpad-t410>
 <4EE7B85E.3070802@lwfinger.net>
 <20111213212606.GB30788@thinkpad-t410>
 <4EE82CC6.2030307@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EE82CC6.2030307@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 13, 2011 at 10:57:42PM -0600, Larry Finger wrote:
> Seth,
> 
> On 12/13/2011 03:26 PM, Seth Forshee wrote:
> >
> >The capture files are available at:
> >
> >http://people.canonical.com/~sforshee/rtl8188ce/
> 
> The major difference is that the "bad" AP implements 802.11n HT40
> technology, but the "good" one does not.
> 
> There was a period when rtl8192ce and rtl8192cu had a bug that
> prevented them from associating with 802.11n APs, but that was fixed
> a long time ago. I can communicate with my Netgear WNDR3300 AP that
> implements full 802.11 capabilities.
> 
> What kernel are you running? If you implement the bleeding-edge
> compat-wireless release, does that help.

I'm running 3.2-rc5 currently. The results are the same with
bleeding-edge compat-wireless.

Seth
