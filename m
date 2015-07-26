Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0146.outbound.protection.outlook.com ([157.56.112.146]:38726
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755221AbbGZQgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 12:36:11 -0400
From: "Joglekar, Tejas (T.)" <tjogleka@visteon.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au:core:rtw_sreset.c:Fix for space related
 error
Date: Sun, 26 Jul 2015 16:36:07 +0000
Message-ID: <20150726163600.GA3341@tejas-asus.domain.name> (sfid-20150726_183627_029941_BC2204F0)
References: <20150726074009.GA14066@tejas-asus.domain.name>
 <wrfjd1zful94.fsf@redhat.com>
In-Reply-To: <wrfjd1zful94.fsf@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 26, 2015 at 09:00:23AM -0400, Jes Sorensen wrote:
> "Joglekar, Tejas (T.)" <tjogleka@visteon.com> writes:
> > From: Joglekar Tejas <tjogleka@visteon.com>
> >
> > This patch fixes the error given by checkpatch.pl
> >
> > Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
> > ---
> >  drivers/staging/rtl8723au/core/rtw_sreset.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/rtl8723au/core/rtw_sreset.c b/drivers/staging/rtl8723au/core/rtw_sreset.c
> > index 29a29d9..48b7723 100644
> > --- a/drivers/staging/rtl8723au/core/rtw_sreset.c
> > +++ b/drivers/staging/rtl8723au/core/rtw_sreset.c
> > @@ -71,7 +71,7 @@ static void sreset_restore_security_station(struct rtw_adapter *padapter)
> >  			/* pairwise key */
> >  			rtw_setstakey_cmd23a(padapter, (unsigned char *)psta, true);
> >  			/* group key */
> > -			rtw_set_key23a(padapter,&padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
> > +			rtw_set_key23a(padapter, &padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
> >  		}
> >  	}
> >  }
> 
> NAK!
> 
> If you are 'fixing' checkpatch 'errors', do it properly and break down
> the line and solve the 80 character limit 'error' as well.
> 
> Jes

Jes ,
Sure, I will break down the line, and remove the 80 character limit issue , before resending the patch.

Thanks & Regards,
Tejas Joglekar