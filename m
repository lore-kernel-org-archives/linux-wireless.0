Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56764 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760409AbYAKRSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 12:18:04 -0500
Message-ID: <4787A4AB.5060601@lwfinger.net> (sfid-20080111_171813_368010_DD6E1D3C)
Date: Fri, 11 Jan 2008 10:17:31 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Martin Marques <martin@marquesminen.com.ar>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Add support for new firmware
References: <200801102046.56979.mb@bu3sch.de> <47879BE4.7040108@lwfinger.net> <47879CBD.8080403@marquesminen.com.ar>
In-Reply-To: <47879CBD.8080403@marquesminen.com.ar>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Marques wrote:
> 
> Sorry if it's a change of subject, but what does the flashing caps hang
> mean? It has happend to me a lot when trying to run 3D apps.

AFAIK, it indicates an error so severe that the kernel has no chance to recover. Examples might be
stack underflow or a page fault while accessing the stack.

Your crashes when running 3D apps is likely a bug in the driver for your graphics adapter. Are you
using a binary-only driver? If so, complain to the manufacturer. If it is an open-source driver,
then a note to the Linux Kernel Mailing List would be appropriate. You should describe your kernel,
configuration, etc. and list the 3D app that causes the problem.

Larry
