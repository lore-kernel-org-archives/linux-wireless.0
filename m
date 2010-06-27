Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:46807 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0F0CUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 22:20:21 -0400
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Date: Sun, 27 Jun 2010 11:20:11 +0900
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006270107.59150.br1@einfach.org> <4C263EC9.12342.C4FBB@jafojtik.seznam.cz>
In-Reply-To: <4C263EC9.12342.C4FBB@jafojtik.seznam.cz>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006271120.11785.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 June 2010 02:54:17 you wrote:
> It looks, that your patch really returns back proper signal values.
> 
> I will not poison Email with png files, feel free to look at here:
>   http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
> Magenta line returned back to green line from other direction.
> 
> 
> Even in an AP mode the magenta line also jumped to expected value:
>   http://78.108.103.11:11080/tmp/klienti-day-big.png
> 
> I hope that this patch would not influence performance or any other
> functionality.

no it just fixes a regression i have introduced in an earlier change. thanks 
for reporting and testing this! i will send the patch for inclusion on monday, 
then it might take some time (few days to weeks) until it apperars in compat-
wireless.

bruno
