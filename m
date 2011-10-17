Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.uc3m.es ([163.117.176.131]:38525 "EHLO smtp01.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1JQOtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:49:21 -0400
Received: from mail-dy0-f46.google.com (mail-dy0-f46.google.com [209.85.220.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by smtp01.uc3m.es (Postfix) with ESMTP id E9FF6BAEB57
	for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 16:49:18 +0200 (CEST)
Received: by dyf17 with SMTP id 17so25988dyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 07:49:18 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?= <agsaaved@it.uc3m.es>
Date: Mon, 17 Oct 2011 16:48:58 +0200
Message-ID: <CADxqDgGcZRgwda6cKs0mfmZnFRoVhvmSoeYWiNapNcgQ9BtV3Q@mail.gmail.com> (sfid-20111017_164923_941292_83E9B115)
Subject: [ BCM4329 ] Sleep/Quiet commands
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am looking for a way of commanding the NIC to go sleep (or stay
quiet) for a certain duration of time (within the bcm4329 GPL driver).
Could anyone could give some pointer to start looking into this?
My final goal is to use this driver with an android phone (e.g., nexus one)

Thanks in advance,
Andrés
