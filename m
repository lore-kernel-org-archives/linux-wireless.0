Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:31776 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756754Ab0FUB1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 21:27:51 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0857913665
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 10:27:49 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values
Date: Mon, 21 Jun 2010 10:26:48 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>
In-Reply-To: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201006211026.48484.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon June 21 2010 04:20:51 Jaroslav Fojtik wrote:
> Dears,
> 
> Look at the attached chart.
> 
> After upgrading from compat-wireless-2010-06-13 to
> compat-wireless-2010-06-18 the reported signal drops from -65dB to -77dB.
> 
> The ATH5k simply lies, because green line in reverse direction did not
> change. The second point has bullet.
> 
> Only purple line dropped.
> 
> But from my point of view the purple line should be comparable with green
> line (measured by bullet). If somebody is interested in experiment, I could
> fiddle with Tx power on a bullet and chart a response.

hi jara!

are you sure it has to do with the upgrade from compat-wireless-2010-06-13 to 
compat-wireless-2010-06-18? i don't see any relevant differences in the code 
between these two versions...

it might be interresting to see what results you get from noise calibration. 
you can enable calibration debugging with "echo calib > 
/sys/kernel/debug/ath5k/phy0/debug"

bruno
