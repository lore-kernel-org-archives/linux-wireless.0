Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:58335 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0FWJBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 05:01:10 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Wed, 23 Jun 2010 11:03:19 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values - "calib" did not help
CC: bruno Randolf <br1@einfach.org>
Message-ID: <4C21CDD7.22303.238050@jafojtik.seznam.cz>
In-reply-to: <201006211650.50766.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C1F135A.26516.F45AB@jafojtik.seznam.cz>, <201006211650.50766.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno & ATH5k developpers,

> > > it might be interresting to see what results you get from noise
> > > calibration. you can enable calibration debugging with "echo calib >
> > > /sys/kernel/debug/ath5k/phy0/debug"
Nothing changed after setting "calib" on. 

ATH5k still reports bad values.

You could see a magenta line here:
  http://78.108.103.11:11080/cgi-bin/rodga.cgi

regards
   Jara
