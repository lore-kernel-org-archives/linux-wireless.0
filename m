Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35732 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbeCTGQq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 02:16:46 -0400
From: "<Hariprasath Elango>" <hariprasath.elango@gmail.com>
Date: Tue, 20 Mar 2018 11:42:27 +0530
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hariprasath.elango@gmail.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] staging: wilc1000: replace switch statement by
 simple if condition
Message-ID: <20180320061227.GA4866@hariprasath> (sfid-20180320_071727_234921_3675340C)
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
 <2a46a5cc8ab69c1143c480bbac1f7e921011d982.1521030891.git.hariprasath.elango@gmail.com>
 <20180319184546.GA17337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180319184546.GA17337@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2018 at 07:45:46PM +0100, Greg KH wrote:
> On Wed, Mar 14, 2018 at 06:15:03PM +0530, hariprasath.elango@gmail.com wrote:
> > From: HariPrasath Elango <hariprasath.elango@gmail.com>
> > 
> > In this case,there is only a single switch case statement.So replacing
> > by a simple if condition.
> > 
> > Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> Does not apply to my tree :(

Hi Greg,

Sorry about that. Shall I sent a v2 after rebasing my repo ? Will that
be fine ? 
