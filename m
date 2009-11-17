Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:54893 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZKQHnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 02:43:07 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2800: do not enable tbtt unless we are in a beacon mode
Date: Tue, 17 Nov 2009 08:41:42 +0100
Cc: Josef Bacik <josef@redhat.com>, ivdoorn@gmail.com,
	users@host1.serialmonkey.com
References: <20091116023317.GA6331@localhost.localdomain>
In-Reply-To: <20091116023317.GA6331@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911170841.43198.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Please be gentle, I'm a fs developer and this is my first foray
> into drivers, as I'm tired of building ralinks driver everytime
> I update my kernel.

We are (sometimes) gentle, but hey, even for FS linux code 
the "please be gentle" shouldn't be part of the commit message, 
but rather be in the comment part of the patch mail.

-- 
http://www.holgerschurig.de
