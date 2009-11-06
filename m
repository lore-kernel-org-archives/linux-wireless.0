Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47960 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbZKFWjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:39:23 -0500
Received: by yxe17 with SMTP id 17so1305594yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:39:28 -0800 (PST)
Subject: Re: Changing from Minstrel to PID
From: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257545606.3752.2.camel@localhost.localdomain>
	 <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 19:40:49 -0300
Message-ID: <1257547249.3752.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El vie, 06-11-2009 a las 17:24 -0500, Bob Copeland escribió:
> On Fri, Nov 6, 2009 at 5:13 PM, Martín Ernesto Barreyro
> <barreyromartin@gmail.com> wrote:
> >> No, but I wish there were...patches?  Anyone?
> >
> > Sorry for my ignorance, but how could I send a parameter to a module or
> > use a configuration file? could be with sysctl?
> 
> You do have to compile them both, but once you do, if you
> have debugfs mounted, you can do:
> 
> echo 'pid' > /debug/ieee80211/phy0/rc/name
> 
> to switch to pid.
> 
Humm, if thats the only way, its better to recompile and forget about
it.

It would be nice if a could change some file in /etc and never care for
kernel upgrades.
I don't know much about kernel developing, i'm just wondering

Something better than adding echo 'pid' > /debug/ieee80211/phy0/rc/name
to rc.local

-- 
Martín Ernesto Barreyro <barreyromartin@gmail.com>
Analista Universitario en Redes de Datos.

