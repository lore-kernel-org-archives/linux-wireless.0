Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:57801 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0FJGsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 02:48:13 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id 3CA5E147655
	for <linux-wireless@vger.kernel.org>; Thu, 10 Jun 2010 08:48:09 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Thu, 10 Jun 2010 08:49:51 +0200
MIME-Version: 1.0
Subject: Re: Compilation problems with Linux-2.6.34 and compat-wireless
Message-ID: <4C108B0F.12989.BAFA3@jafojtik.seznam.cz>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear John W. Linville,

> I'm guessing you need CONFIG_WIRELESS_EXT in /usr/src/linux-2.6.34/.config ?
I do not know how to turn CONFIG_WIRELESS_EXT in linux 2.6.34. 
This option no longer exists.

When I add:
CONFIG_WIRELESS_EXT=y
 into .config file, it is automatically erased.

I guess that:
CONFIG_WIRELESS_EXT=y  has been renamed to 
CONFIG_WIRELESS_WEXT=y

regards
   Jara

> 
> John
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

