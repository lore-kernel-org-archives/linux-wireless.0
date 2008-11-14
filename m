Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:4735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYKNDgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 22:36:07 -0500
Received: by fg-out-1718.google.com with SMTP id 19so984376fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 19:36:05 -0800 (PST)
Message-ID: <3e45db430811131936y45a51f8bj4ee2a073db5f4313@mail.gmail.com> (sfid-20081114_043613_124174_0FB181C4)
Date: Thu, 13 Nov 2008 22:36:05 -0500
From: "Sylvain Lamontagne" <sylvain.lamontagne@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Embedded System using Sparklan WMIA-166AGI
In-Reply-To: <3e45db430811131534x6606aacaka333db207175b9c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <3e45db430811131534x6606aacaka333db207175b9c7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody

We are currently developing a new product that have a Sparklan
WMIA-166AGI (Chipset:Atheros AR5006XS  AR5414) Mini-PCI wireless card
on it. The system is an embedded computer and I would like to know if
any of of you have been able to use this card with the ath5k driver?

I had it working properly using a linux kernel 2.6.23 and the Madwifi
driver, but now the development must be done with a kernel 2.6.27 and
I have been unlucky trying to make it work with madwifi. Since I read
that madwifi is goind dead, I'm trying to get it working with ath5k.

Any advice are welcome, also when it will be compiled, how can I use
the device ? Do I have to simply use the wireless-tools package ? Or
is there something else ?
How is the status of the Access Point Mode for this card ?
Do you have any technical information about this card (Datasheet,
Spec, BOM, etc...) ?

I can understand and look at some code if needed...

Sly
