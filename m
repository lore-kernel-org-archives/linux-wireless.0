Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3GJHzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 03:55:47 -0400
Date: Wed, 10 Jul 2013 09:58:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hendrik-Jan Heins <hjheins@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: intel 4965 fails to set channel 12 or 13
Message-ID: <20130710075833.GA1544@redhat.com> (sfid-20130710_095550_698687_C2D0B966)
References: <CAAU0D9dyrsHKw6cvbfNnhodQOC9_Bhxm0xiDqmKXTuN8Lby3DQ@mail.gmail.com>
 <20130709141312.GA3681@redhat.com>
 <CAAU0D9d5XKkRgAexQomR+EqCjpP5ZSf-jYgCgd617vpDum9b+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAU0D9d5XKkRgAexQomR+EqCjpP5ZSf-jYgCgd617vpDum9b+g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 09, 2013 at 08:00:19PM +0200, Hendrik-Jan Heins wrote:
> 		Frequencies:
> 			* 2412 MHz [1] (14.0 dBm)
> 			* 2417 MHz [2] (14.0 dBm)
> 			* 2422 MHz [3] (14.0 dBm)
> 			* 2427 MHz [4] (14.0 dBm)
> 			* 2432 MHz [5] (14.0 dBm)
> 			* 2437 MHz [6] (14.0 dBm)
> 			* 2442 MHz [7] (14.0 dBm)
> 			* 2447 MHz [8] (14.0 dBm)
> 			* 2452 MHz [9] (14.0 dBm)
> 			* 2457 MHz [10] (14.0 dBm)
> 			* 2462 MHz [11] (14.0 dBm)
> 		Bitrates (non-HT):

Your device does not support channels 12 & 13. This limit is coded
in device EEPROM. Is not possible to workaround that in driver or
user space, as (closed source) firmware will force EEPROM regulatory
limits. 
 
Stanislaw
