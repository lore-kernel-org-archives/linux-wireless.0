Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33068 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbcFTP7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 11:59:53 -0400
Received: by mail-yw0-f178.google.com with SMTP id v77so21742187ywg.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 08:59:44 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 20 Jun 2016 20:36:02 +0530
Message-ID: <CABPxzY+NT6+-1+HmuF3uWiOEAxyzUPZtULiGTgeFc1EgXGd+xw@mail.gmail.com> (sfid-20160620_180149_665404_AF7BEC0B)
Subject: STBC and LDPC for VHT
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What is the background for disabling STBC and LDPC for
VHT rates? The below comment is cryptic :-).

/* TODO tx_flags for vht - ATM the RC API is not fine-grained enough */

Can we just enable these now?
