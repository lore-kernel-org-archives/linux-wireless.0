Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:38306 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0JHKdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 06:33:50 -0400
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Content-Type: text/plain; charset=us-ascii
Subject: Problem building toolchain for carl9170 firmware
Date: Fri, 8 Oct 2010 12:25:02 +0200
Message-Id: <D32D2F14-8C3B-44D8-B33C-AF9658E38BD3@ing.unibs.it>
Cc: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

I'm trying to build the toolchain to compile the firmware but I get this error

wget -P src http://mirrors.kernel.org/gnu/binutils/binutils-2.20.51.tar.bz2
--12:11:06--  http://mirrors.kernel.org/gnu/binutils/binutils-2.20.51.tar.bz2
           => `src/binutils-2.20.51.tar.bz2'
Resolving mirrors.kernel.org... 199.6.1.174, 130.239.17.6
Connecting to mirrors.kernel.org|199.6.1.174|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
12:11:08 ERROR 404: Not Found.

Though I know binutils-2.20.51.tar.bz2 exists, it is not listed in the mirrors that wget contacts (maybe some mirrors still do not host it?) I solved by downloading it from sourceforge.

Kind regards,
-Francesco


Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


