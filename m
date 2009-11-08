Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50174 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZKHPoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 10:44:38 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2428901ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 07:44:43 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v3] rt2x00: Update copyright statements.
Date: Sun, 8 Nov 2009 16:44:41 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257694795-7874-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257694795-7874-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081644.41599.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> As mentioned on the linux-wireless mailing list, the current copyright statements in the rt2x00 are
> meaningless, as the rt2x00 project is not even a formal legal entity. Therefore it is better to replace
> the existing copyright statements with copyright statements for the people that actually wrote the code.
> 
> Note: Updated to the best of my knowledge with respect to who contributed considerable amounts of code.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: Ivo van Doorn <IvDoorn@gmail.com>
> CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> v2:
> - Handle feedback from Ivo.
> 
> v3:
> - Handle feedback from Bart.
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2400pci.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2500pci.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2500pci.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2500usb.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2500usb.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2800.h         |    9 ++++++++-
>  drivers/net/wireless/rt2x00/rt2800lib.c      |   13 +++++++++----
>  drivers/net/wireless/rt2x00/rt2800pci.c      |    9 ++++++++-
>  drivers/net/wireless/rt2x00/rt2800pci.h      |    9 ++++++++-
>  drivers/net/wireless/rt2x00/rt2800usb.c      |    6 +++++-
>  drivers/net/wireless/rt2x00/rt2800usb.h      |    6 +++++-
>  drivers/net/wireless/rt2x00/rt2x00.h         |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00config.c   |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00crypto.c   |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00debug.c    |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00debug.h    |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00dev.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00dump.h     |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00firmware.c |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00ht.c       |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00leds.c     |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00leds.h     |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00lib.h      |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00link.c     |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00mac.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00queue.c    |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00queue.h    |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00reg.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00soc.c      |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00soc.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00usb.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00usb.h      |    2 +-
>  drivers/net/wireless/rt2x00/rt61pci.c        |    2 +-
>  drivers/net/wireless/rt2x00/rt61pci.h        |    2 +-
>  drivers/net/wireless/rt2x00/rt73usb.c        |    2 +-
>  drivers/net/wireless/rt2x00/rt73usb.h        |    2 +-
>  39 files changed, 81 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 798f625..0f912f5 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
> index ccd6441..6c21ef6 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 2e872ac..6618cbd 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
> index 54d3795..b007567 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 22dd6d9..35e5297 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
> index b01edca..341a704 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index d9b6a72..7ab85d7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1,5 +1,12 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 5c7d74a..24b3af4 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1,9 +1,14 @@
>  /*
> -	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
> -
> -	Based on the original rt2800pci.c and rt2800usb.c:
> -
> -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> +
> +	Based on the original rt2800pci.c and rt2800usb.c.
> +	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	  Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> +	  Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	  Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> +	  Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	  Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> +	  Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>  	  <http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 2f284a6..ac7ac57 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1,5 +1,12 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
> index 8f944ee..6ae9cbd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -1,5 +1,12 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 3168ad4..d22ab64 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1,5 +1,9 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	Copyright (C) 2009 Axel Kollhofer <rain_maker@root-forum.org>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
> index c9d7d40..1cd2c8d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.h
> @@ -1,5 +1,9 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	Copyright (C) 2009 Axel Kollhofer <rain_maker@root-forum.org>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index c83dbae..fd13264 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -1,5 +1,6 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index 40a201e..098315a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> index de36837..d291c78 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index 68bc9bb..7d323a7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
> index 035cbc9..fa11409 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 73bbec5..ba2830c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
> index fdedb51..727019a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dump.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> index d2deea2..34beb00 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> @@ -1,5 +1,6 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
> index e3cec83..1056c92 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00ht.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
> index 49671fe..ca585e3 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00leds.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.h b/drivers/net/wireless/rt2x00/rt2x00leds.h
> index 8e03c04..3b46f0c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00leds.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 567f029..c71154e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -1,5 +1,6 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
> index c708d0b..7083e85 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00link.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00link.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 929b85f..eed093d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index ece70d7..0feb4d0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
> index ae33eeb..d4f9449 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 577029e..02972a0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -1,5 +1,6 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index a5591fb..97c7895 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> index 983e52e..603bfc0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
> index 4abcfa6..19e684f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
> @@ -1,5 +1,6 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2004 - 2009 Felix Fietkau <nbd@openwrt.org>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
> index 5cf114a..8a34166 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index aa6c31d..0a751e7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
> index 9943e42..d63e1df 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index b20e3ea..ea8a86f 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
> index 93eb699..6f33f7f 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.h
> +++ b/drivers/net/wireless/rt2x00/rt61pci.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 14e7bb2..7236f01 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
> index 81fe0be..e783a09 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.h
> +++ b/drivers/net/wireless/rt2x00/rt73usb.h
> @@ -1,5 +1,5 @@
>  /*
> -	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
>  	<http://rt2x00.serialmonkey.com>
>  
>  	This program is free software; you can redistribute it and/or modify


