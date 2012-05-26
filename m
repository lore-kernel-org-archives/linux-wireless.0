Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37029 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2EZR61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:58:27 -0400
Received: by wibhj8 with SMTP id hj8so510091wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 May 2012 10:58:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Anyone doing WiFi throughput tests?
Date: Sat, 26 May 2012 19:58:22 +0200
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com>
In-Reply-To: <4FC0F8CE.1030303@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205261958.22934.chunkeey@googlemail.com> (sfid-20120526_195830_979538_0CEEB612)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2012 17:37:50 Ben Greear wrote:
> We're using WPEA-127N.  We have a dual-core Atom for one system, and
> a quad-core i7 CPU (and two wifi NICs) in another system..  So far,
> the Atom with single NIC is benchmarking better in some tests.  We
> were only using one of the NICs in the i7 for testing, but maybe
> there is still some interference or maybe we just had bad antenna
> placement or something.
> 
> We've used various Asus and Netgear APs...haven't done throughput
> tests with home-grown APs running Atheros NICs recently, but will
> do so next week.
> 
> > With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP) can reach 290 Mbps.
> 
> What chipset or brand/model is this?  I see that XB112 mentioned
> in the WPEA-127N description, but maybe that is just a form-factor
> description?

Well, Atheros made some nice presentations about that:
<http://wenku.baidu.com/view/ac0523f57c1cfad6195fa7f4.html>
take a look at slide 12. It has 11n technology (2x2 vs
3x3 ZF vs ML vs CC vs LDPC vs (TxBF) vs range vs tcp
throughput all on one diagramm)

Regards,
	Chr
