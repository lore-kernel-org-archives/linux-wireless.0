Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suteba.org.ar ([200.16.134.105]:50550 "EHLO
        mail.suteba.org.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161402AbcIZPpP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:45:15 -0400
From: Matias Mucciolo <mmucciolo@suteba.org.ar>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: fix symbol 'WILC_DEBUG_LEVEL' was not declared.
Date: Mon, 26 Sep 2016 12:44:24 -0300
Message-ID: <4399555.QWNJt8EtNN@varitech> (sfid-20160926_174548_531728_E70F1B39)
In-Reply-To: <20160926153733.GA1723@kroah.com>
References: <34310025.aMSyYASYEz@varitech> <20160926153733.GA1723@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


hi

sorry...this is the full warning:

drivers/staging/wilc1000/wilc_debugfs.c:32:10: warning: symbol 'WILC_DEBUG_LEVEL' was not declared. Should it be static?


-- 

Matias Mucciolo

Area de Infraestructura.
Piedras 737 C.A.B.A 
SUTEBA 

On Monday 26 September 2016 17:37:33 Greg Kroah-Hartman wrote:
> On Mon, Sep 26, 2016 at 12:15:18PM -0300, Matias Mucciolo wrote:
> > 
> > - Fixed a sparse warning: symbol 'WILC_DEBUG_LEVEL' was not declared.
> 
> I don't think that was the full warning, as that does not make much
> sense to me, does it to you?
> 
> thanks,
> 
> greg k-h
