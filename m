Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from maikjaekel.de ([79.143.179.117]:48111 "EHLO maikjaekel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab3ABUFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 15:05:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by maikjaekel.de (Postfix) with ESMTP id 00BE21CE341
	for <linux-wireless@vger.kernel.org>; Wed,  2 Jan 2013 20:58:15 +0100 (CET)
Received: from maikjaekel.de ([127.0.0.1])
	by localhost (maikjaekel.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id f-S7PLeZgwNn for <linux-wireless@vger.kernel.org>;
	Wed,  2 Jan 2013 20:58:14 +0100 (CET)
Received: from maikjaekel.de (maikjaekel.de [127.0.1.1])
	by maikjaekel.de (Postfix) with ESMTP id 596D21CE340
	for <linux-wireless@vger.kernel.org>; Wed,  2 Jan 2013 20:58:14 +0100 (CET)
Date: Wed, 2 Jan 2013 20:58:14 +0100 (CET)
From: Maik =?utf-8?Q?J=C3=A4kel?= <email@maikjaekel.de>
To: linux-wireless@vger.kernel.org
Message-ID: <25833857.43311.1357156694151.JavaMail.root@maikjaekel.de> (sfid-20130102_210513_391024_40DC07F9)
Subject: Adding a nanosecond timestamp to the beacon frame
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey everyone,

I'm trying to add a timestamp with nanosecond resolution to my beacon frames. After searching through the code I cannot decide at which I place I have to add the timestamp... 
My target device uses an Ralink Rt305x chipset but I thought that this modification should not be depending on the hardware it is running on. So my question is:

Where and how do I have to add the nanosecond timestamp?


Best regards and thanks in advance,
Maik Jäkel
