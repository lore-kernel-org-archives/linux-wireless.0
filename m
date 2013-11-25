Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02a.posteo.de ([89.146.194.168]:37135 "EHLO mx02a.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3KYSEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 13:04:31 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.posteo.de (Postfix) with ESMTP id 53BE12F9EDF
	for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 17:57:42 +0000 (UTC)
Received: from posteo.de ([10.125.125.134])
	by localhost (amavis1.posteo.de [10.125.125.165]) (amavisd-new, port 10026)
	with ESMTP id UuRwlzmBsya2 for <linux-wireless@vger.kernel.org>;
	Mon, 25 Nov 2013 18:57:32 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by mail.posteo.de (Postfix) with ESMTPSA id 931D920027122
	for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 18:57:32 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 25 Nov 2013 18:57:32 +0100
From: p2p@posteo.de
To: <linux-wireless@vger.kernel.org>
Subject: RTL8188S
Message-ID: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> (sfid-20131125_190434_459533_2DD9B1F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a WLAN dongle with Realtek RTL8188S chip.
I don't want to use r8712u driver with wext interface because I want to 
establish a wifi direct p2p connection.
Unfortunately the original Realtek driver from hp didn't work with p2p 
too.
I thought RTL8192cu will work, but Larry F. told me it doesn't.

He said there is a new driver in development.
I'm searching for information. Please can someone tell me about the 
project, its status, and if someone can take part.

Best regards
p2p
