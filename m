Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47769 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2DIWQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 18:16:29 -0400
Received: by iagz16 with SMTP id z16so6441268iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 15:16:29 -0700 (PDT)
Message-ID: <4F835FB9.5020100@lwfinger.net> (sfid-20120410_001633_018344_1767724D)
Date: Mon, 09 Apr 2012 17:16:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jan Simonson <jan@simonson.se>, linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer> <4F81B9C4.1010901@lwfinger.net> <2210309.p6dWLepooK@ymer> <4F8306CF.4040503@lwfinger.net> <20120409192630.GB26994@tuxdriver.com>
In-Reply-To: <20120409192630.GB26994@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2012 02:26 PM, John W. Linville wrote:
> On Mon, Apr 09, 2012 at 10:57:03AM -0500, Larry Finger wrote:
>
>> As I do not use Fedora, I was not aware of Fusion. Perhaps you could
>> get them to reinstate this driver in their package. In addition, you
>> might post a bug at Redhat in hopes that they will change their
>> standard configuration. As a last resort, you could switch to a
>> distro that includes this driver in their standard kernels.
>
> Yeah, this is reasonable advice.  I don't know why Fusion droped this
> package, but it might have been due to me making their life harder by
> integrating compat-wireless directly into the Fedora kernels.  Since I
> am no longer doing that, they may be willing to reverse that decision.
>
> I don't really see including a staging driver in Fedora unless it is
> clearly on the path to the "normal" part of the kernel.  Any chance
> of that?

Yes, but not likely very soon. This card is relatively rare, and there are 
several drivers for more common Realtek devices in staging.

@Jan - There is one other option. As you can compile drivers, I will prepare a 
tested copy of the driver that will compile on all recent kernels, and put the 
source on my ftp site.

Larry

