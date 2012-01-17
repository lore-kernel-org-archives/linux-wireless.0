Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2AQTdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 14:33:18 -0500
Received: by werb14 with SMTP id b14so1403596wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 11:33:16 -0800 (PST)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Tue, 17 Jan 2012 20:32:55 +0100
Message-ID: <CADxqDgEwdmR0k_Fvng10fCAb3W_UNyV2AH_R-Vyxp8WqbRafZg@mail.gmail.com> (sfid-20120117_203322_415588_31D225B1)
Subject: [ atheros ] DCU transmit pause control/status register
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am looking of a way for pausing/continuing the actual transmission
of packets in queues (for research purposes). I noticed these
registers avaiblable in atheros cards: AR5K_DCU_TXP in ath5k o
AR_D_TXPSE in ath9k.  Does anyone know how these work and can give me
a hint?

Thanks in advance,

Andrés
