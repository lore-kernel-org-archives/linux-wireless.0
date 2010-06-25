Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:5287 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753862Ab0FYAtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 20:49:11 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0931866946
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 09:49:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values - "calib" did not help
Date: Fri, 25 Jun 2010 09:47:38 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006211650.50766.br1@einfach.org> <4C21CDD7.22303.238050@jafojtik.seznam.cz>
In-Reply-To: <4C21CDD7.22303.238050@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006250947.39223.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed June 23 2010 18:03:19 Jaroslav Fojtik wrote:
> Dear Bruno & ATH5k developpers,
> 
> > > > it might be interresting to see what results you get from noise
> > > > calibration. you can enable calibration debugging with "echo calib >
> > > > /sys/kernel/debug/ath5k/phy0/debug"
> 
> Nothing changed after setting "calib" on.
> 
> ATH5k still reports bad values.
> 
> You could see a magenta line here:
>   http://78.108.103.11:11080/cgi-bin/rodga.cgi
> 
> regards
>    Jara

hey jara!

setting "calib" is not supposed to change the results, it would just show us 
debug messages in the kernel log (dmesg). have you tried the patch i sent 
later? that should fix it...

bruno
