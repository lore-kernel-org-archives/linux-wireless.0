Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:42984 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0FUHVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 03:21:01 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Mon, 21 Jun 2010 09:23:06 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values
CC: Bruno Randolf <br1@einfach.org>
Message-ID: <4C1F135A.26516.F45AB@jafojtik.seznam.cz>
In-reply-to: <201006211026.48484.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <201006211026.48484.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno,

> hi jara!
> 
> are you sure it has to do with the upgrade from compat-wireless-2010-06-13 to 
> compat-wireless-2010-06-18? i don't see any relevant differences in the code 
> between these two versions...
  Sorry, it might be compat-wireless-2010-05-30. 
I have tested only 3 versions.

Anyway, I have observed "false" signal drop even for client stations.

You could see that purple line als dropped from -61 to -71 without any reason:
http://78.108.103.11:11080/cgi-bin/klienti_year.cgi


> it might be interresting to see what results you get from noise calibration. 
> you can enable calibration debugging with "echo calib > 
> /sys/kernel/debug/ath5k/phy0/debug"
The directory /sys/kernel/debug is empty. 
It looks that I have to recompile kernel. Or do you know any option to 
pass to kernel to allow this feature?

regards
   Jara

