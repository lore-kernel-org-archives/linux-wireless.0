Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47637 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753929Ab1EYUEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 16:04:42 -0400
Date: Wed, 25 May 2011 13:04:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
Message-Id: <20110525130438.c05605c7.rdunlap@xenotime.net> (sfid-20110525_220501_411727_A1B8FAA4)
In-Reply-To: <1306352426-1899-1-git-send-email-arend@broadcom.com>
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 May 2011 21:40:26 +0200 Arend van Spriel wrote:

> diff --git a/include/linux/cordic.h b/include/linux/cordic.h
> new file mode 100644
> index 0000000..28443a6
> --- /dev/null
> +++ b/include/linux/cordic.h
> @@ -0,0 +1,48 @@

> +/**
> + * struct - i/q coordinate.

 * struct cordic_iq - i/q coordinate

> + *
> + * @i: real part of coordinate (in phase).
> + * @q: imaginary part of coordinate (quadrature).
> + */
> +struct cordic_iq {
> +	s32 i;
> +	s32 q;
> +};


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
