Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38844 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbeCTLaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 07:30:14 -0400
Date: Tue, 20 Mar 2018 14:29:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "<Hariprasath Elango>" <hariprasath.elango@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 5/7] staging: wilc1000: replace switch statement by
 simple if condition
Message-ID: <20180320112951.wgrd76pxsu3qgk6r@mwanda> (sfid-20180320_123018_942772_7E362451)
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
 <2a46a5cc8ab69c1143c480bbac1f7e921011d982.1521030891.git.hariprasath.elango@gmail.com>
 <20180319184546.GA17337@kroah.com>
 <20180320061227.GA4866@hariprasath>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320061227.GA4866@hariprasath>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 11:42:27AM +0530, <Hariprasath Elango> wrote:
> On Mon, Mar 19, 2018 at 07:45:46PM +0100, Greg KH wrote:
> > On Wed, Mar 14, 2018 at 06:15:03PM +0530, hariprasath.elango@gmail.com wrote:
> > > From: HariPrasath Elango <hariprasath.elango@gmail.com>
> > > 
> > > In this case,there is only a single switch case statement.So replacing
> > > by a simple if condition.
> > > 
> > > Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> > > ---
> > >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
> > >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > Does not apply to my tree :(
> 
> Hi Greg,
> 
> Sorry about that.

Probably there were other patches on the list that were applied first.
It's likely not your fault, but just part of the process.

> Shall I sent a v2 after rebasing my repo ? Will that
> be fine ? 

Yes.

regards,
dan carpenter
