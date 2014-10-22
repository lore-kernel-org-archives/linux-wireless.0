Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:42320 "EHLO
	minos.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754909AbaJVQE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:04:26 -0400
Message-ID: <5447CF6D.3010401@mailservices.uwaterloo.ca> (sfid-20141022_180433_586761_5297CAD0)
Date: Wed, 22 Oct 2014 11:38:21 -0400
From: Ali Abedi <a2abedi@uwaterloo.ca>
MIME-Version: 1.0
To: "(ath9k-devel@lists.ath9k.org)" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
Subject: Block ACK without frame aggregation
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am interested to know if we can send multiple packets (non-aggregated, 
single packets) and then ask
for a block ACK? I like to know if this functionality has been 
implemented in ath9k or if
it is possible to achieve this with slight code modifications.

What I need:
Frame-SIFS-Frame-SIFS-Frame-SIFS-REQ Block ACK-SIFS-Block ACK

Best,
Ali
