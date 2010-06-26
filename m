Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:36062 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0FZQQB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 12:16:01 -0400
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values - "calib" did not help
Date: Sun, 27 Jun 2010 01:07:59 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006250947.39223.br1@einfach.org> <4C25F603.29925.1365B7A@jafojtik.seznam.cz>
In-Reply-To: <4C25F603.29925.1365B7A@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006270107.59150.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 June 2010 21:43:47 Jaroslav Fojtik wrote:
> I do not know which patch do you mean. If it is integrated into a current
> tarball, I could simply download it and try it.
> http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2010-06
> -25.tar.bz2
> 
> If it is not, please Email me such patch.

i dont have it here right now, but i sent it in a previous reply to you:

http://marc.info/?l=linux-wireless&m=127717933410893&w=2

it's just one line, so you can also change the same line in your compat-
wireless source code.

> I am currently using compat-wireless-2010-06-22 and it is still affected by
> wrong signal measurement.

yes, my patch is not part of compat-wireless yet. if you confirm that it fixes 
your problem i will send it for inclusion.
 
bruno
