Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54544 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849AbZKFV2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 16:28:07 -0500
Received: by yxe17 with SMTP id 17so1260486yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 13:28:12 -0800 (PST)
Subject: Changing from Minstrel to PID
From: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 18:29:16 -0300
Message-ID: <1257542956.6565.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I have a rtl8187 wireless card and I've allways have problems
with the rate control using minstrel. So everytime my kernel updates
(recently it went from 2.30 to 2.31) i have to recompile mi kernel
setting pid as my default rate control algorithm.

Is there a way to change that without compiling the kernel?


-- 
Martín Ernesto Barreyro <barreyromartin@gmail.com>
Analista Universitario en Redes de Datos.

