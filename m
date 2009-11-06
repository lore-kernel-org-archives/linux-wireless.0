Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:41168 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904AbZKFWME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:12:04 -0500
Received: by ywh40 with SMTP id 40so1289657ywh.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:12:10 -0800 (PST)
Subject: Re: Changing from Minstrel to PID
From: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091106214803.GL2782@tuxdriver.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 19:13:26 -0300
Message-ID: <1257545606.3752.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El vie, 06-11-2009 a las 16:48 -0500, John W. Linville escribió:
> On Fri, Nov 06, 2009 at 06:29:16PM -0300, Martín Ernesto Barreyro wrote:
> > Hello, I have a rtl8187 wireless card and I've allways have problems
> > with the rate control using minstrel. So everytime my kernel updates
> > (recently it went from 2.30 to 2.31) i have to recompile mi kernel
> > setting pid as my default rate control algorithm.
> > 
> > Is there a way to change that without compiling the kernel?
> 
> No, but I wish there were...patches?  Anyone?

Sorry for my ignorance, but how could I send a parameter to a module or
use a configuration file? could be with sysctl?


-- 
Martín Ernesto Barreyro <barreyromartin@gmail.com>
Analista Universitario en Redes de Datos.

