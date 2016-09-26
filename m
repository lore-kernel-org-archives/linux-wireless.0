Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934254AbcIZPhp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:37:45 -0400
Date: Mon, 26 Sep 2016 17:37:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matias Mucciolo <mmucciolo@suteba.org.ar>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: fix symbol 'WILC_DEBUG_LEVEL' was not
 declared.
Message-ID: <20160926153733.GA1723@kroah.com> (sfid-20160926_173846_541814_140A704C)
References: <34310025.aMSyYASYEz@varitech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <34310025.aMSyYASYEz@varitech>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2016 at 12:15:18PM -0300, Matias Mucciolo wrote:
> 
> - Fixed a sparse warning: symbol 'WILC_DEBUG_LEVEL' was not declared.

I don't think that was the full warning, as that does not make much
sense to me, does it to you?

thanks,

greg k-h
