Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46004 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2KNTsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 14:48:36 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so1142218iea.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2012 11:48:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211141726190.23195@lap-x201>
References: <alpine.DEB.2.02.1211141726190.23195@lap-x201>
Date: Wed, 14 Nov 2012 21:48:36 +0200
Message-ID: <CAFub=KQV=2HX7jSbY=dBQ9vXKNna1ppchmD3fhGiBvqguYekRw@mail.gmail.com> (sfid-20121114_204840_798519_D556770A)
Subject: Re: compat-drivers 3.7-rc1: cfg80211 fails to load on
 3.0.0-26-generic-pae [AV#3438]
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 14, 2012 at 7:29 PM, Chris Wilson <chris@aptivate.org> wrote:
> Dear developers,
>
> I'm trying to use compat-drivers to gain support for the Intel Centrino
> Wireless-N (iwlwifi driver) on the Ubuntu Oneiric kernel backported to Lucid
> (3.0.0-26-generic-pae). The driver compiles but fails to install, with the
> following error:
>
> [  578.661869] Compat-drivers backport release: compat-drivers-v3.7-rc1-6
> [  578.661879] Backport based on linux-stable.git v3.7-rc1
> [  578.661885] compat.git: linux-stable.git
> [  578.664089] cfg80211: Unknown symbol simple_open (err 0)
>

Are you sure that you installed the modules correctly on your system?
simple_open() is a new symbol that should normally be provided by the
compat layer (compat.ko). Do you have any undefined symbol warnings at
the end of the building process?
