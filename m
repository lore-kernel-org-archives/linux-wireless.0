Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:45461 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3GQQsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 12:48:35 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id AB45D77D902
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 18:48:31 +0200 (CEST)
Received: from zimbra65-e11.priv.proxad.net (unknown [172.20.243.215])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 1D1AF4B01B8
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 18:47:37 +0200 (CEST)
Date: Wed, 17 Jul 2013 18:47:36 +0200 (CEST)
From: etienne.champetier@free.fr
To: linux-wireless@vger.kernel.org
Message-ID: <800088722.345614075.1374079656592.JavaMail.root@zimbra65-e11.priv.proxad.net> (sfid-20130717_184842_603449_43DBAA9B)
In-Reply-To: <242956217.344802091.1374060921158.JavaMail.root@zimbra65-e11.priv.proxad.net>
Subject: authsae & ath9k nohwcrypt=1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'm making some test with authsae on openrwt and for wr1043nd router (AR9100 wireless) i still need 'ath9k nohwcrypt=1'
for the secure mesh to work when on another router (AR9280 wireless) i don't need it.
Is it a drivers bug? or is it hardware?

-Router A: wr1043nd (need nohwcrypt=1 option)
  -AR9100 wireless
  -authsae - 2013-06-25-e2f67612101dc83f2c459d8ddc75c34bc83e1e83 (https://github.com/cozybit/authsae/tree/e2f67612101dc83f2c459d8ddc75c34bc83e1e83)
  -kmod-ath9k - 3.10.1+2013-06-27-1 (backports-20130617-4-ge3220f5)
  -openwrt BB r37364

-Router B: ubnt rspro
  -AR9280 wireless
  -openwrt BB r37369 (same authsae/ath9k)

Thanks in advance
Etienne
