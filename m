Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1279 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZCES7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 13:59:21 -0500
Subject: Re: [PATCH wireless-testing] airo_cs: checkpatch.pl cleanups
From: Joe Perches <joe@perches.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <49AF1BD7.3020508@gmail.com>
References: <49AF1BD7.3020508@gmail.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 11:01:28 -0800
Message-Id: <1236279688.15246.43.camel@localhost> (sfid-20090305_195925_365189_9FE9630F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-04 at 16:24 -0800, John Daiker wrote:
> Hopefully nothing controversial here, since the driver hasn't been touched in a while!
> 
> Before: 36 errors, 6 warnings, 482 lines checked
> After:  0 errors, 3 warnings, 485 lines checked
> 
> This was nearly all trailing whitespace, * and parenthesis spacing, and code indent changes.
> 
> md5sum of object file before and after are identical.
> 
> ---
> 
> Signed-off-by: John Daiker <daikerjohn@gmail.com>
> 
> diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
> index 27696c2..6b96add 100644
> --- a/drivers/net/wireless/airo_cs.c
> +++ b/drivers/net/wireless/airo_cs.c
> @@ -16,8 +16,8 @@
>      In addition this module was derived from dummy_cs.
>      The initial developer of dummy_cs is David A. Hinds
>      <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
> -    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.    
> -    
> +    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
> +
>  ======================================================================*/
>  
>  #ifdef __IN_PCMCIA_PACKAGE__
> @@ -38,7 +38,7 @@
>  #include <pcmcia/cisreg.h>
>  #include <pcmcia/ds.h>
>  
> -#include <asm/io.h>
> +#include <linux/io.h>
>  #include <asm/system.h>
>  
>  #include "airo.h"
> @@ -54,7 +54,7 @@
>  static int pc_debug = PCMCIA_DEBUG;
>  module_param(pc_debug, int, 0);
>  static char *version = "$Revision: 1.2 $";
> -#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args);
> +#define DEBUG(n, args...) if (pc_debug > (n)) printk(KERN_DEBUG args);
>  #else
>  #define DEBUG(n, args...)
>  #endif
> @@ -63,7 +63,7 @@ static char *version = "$Revision: 1.2 $";
>  
>  MODULE_AUTHOR("Benjamin Reed");
>  MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless
> ethernet \
> -                   cards.  This is the module that links the PCMCIA
> card \
> +		   cards.  This is the module that links the PCMCIA card \
>  		   with the airo module.");

This should use " at the start and end of every line.

MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet "
		   "cards.  This is the module that links the PCMCIA card "
		   "with the airo module.");


