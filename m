Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23003 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYAVLxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 06:53:42 -0500
Received: from lin01.mn-solutions.de (pD95F9308.dip0.t-ipconnect.de [217.95.147.8])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id EF9335E45CA
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:53:40 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id A0EB01E000E
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:50:48 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6 (2008-01-21)
Date: Tue, 22 Jan 2008 12:53:40 +0100
References: <20080121202835.GA3065@tuxdriver.com> <200801220856.55024.hs4233@mail.mn-solutions.de> <20080122.022437.07454007.davem@davemloft.net>
In-Reply-To: <20080122.022437.07454007.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801221253.40347.hs4233@mail.mn-solutions.de> (sfid-20080122_115346_128380_D730AD4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What I usually expect, when it isn't clear, is that the first
> "Signed-off-by:" I see is what I use at the author.

Hmm, then the fault doesn't seem to be on my side.

$ git show commit 0196c6a4aec1e420a6bd0b420ff1768fec059d4d

(on the wireless-2.6/everything tree) shows:

    Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
    Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
