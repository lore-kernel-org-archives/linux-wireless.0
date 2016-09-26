Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38583 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941526AbcIZPwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:52:16 -0400
Date: Mon, 26 Sep 2016 17:52:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matias Mucciolo <mmucciolo@suteba.org.ar>
Cc: devel@driverdev.osuosl.org,
        Aditya Shankar <aditya.shankar@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Subject: Re: [PATCH] staging: wilc1000: fix symbol 'WILC_DEBUG_LEVEL' was not
 declared.
Message-ID: <20160926155220.GA3319@kroah.com> (sfid-20160926_175239_190343_1A78D7E9)
References: <34310025.aMSyYASYEz@varitech>
 <20160926153733.GA1723@kroah.com>
 <4399555.QWNJt8EtNN@varitech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4399555.QWNJt8EtNN@varitech>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2016 at 12:44:24PM -0300, Matias Mucciolo wrote:
> 
> hi
> 
> sorry...this is the full warning:
> 
> drivers/staging/wilc1000/wilc_debugfs.c:32:10: warning: symbol 'WILC_DEBUG_LEVEL' was not declared. Should it be static?

the "should it be static" is the key here, right?  Care to fix this up
and resend it?

thanks,

greg k-h
