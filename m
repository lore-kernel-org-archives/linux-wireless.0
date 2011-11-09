Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46048 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1KIHyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 02:54:14 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] NFC: Update names and structs to NCI spec 1.0 d18
Date: Wed, 9 Nov 2011 07:53:52 +0000
Message-ID: <B30D1FD582D6484ABF57420512E58035F739@DNCE03.ent.ti.com> (sfid-20111109_085417_749994_1803755A)
References: <1320152097-2711-1-git-send-email-ilane@ti.com>
	<1320152097-2711-2-git-send-email-ilane@ti.com>
 <CAK3JMAYq62VuPQGdwv=Qu6QnakG6biOQfYDj=kOKaOzW6QdT1Q@mail.gmail.com>
In-Reply-To: <CAK3JMAYq62VuPQGdwv=Qu6QnakG6biOQfYDj=kOKaOzW6QdT1Q@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, 

> >  /* NFCEE Interface Specific Status Codes */
> > -#define        
> NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED          0xc0
> > -#define        
> NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED            0xc1
> > -#define        NCI_STATUS_NFCEE_TRANSMISSION_ERROR         
>             0xc2
> > -#define        NCI_STATUS_NFCEE_PROTOCOL_ERROR             
>             0xc3
> > +#define NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED         0xc0
> > +#define NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED           0xc1
> > +#define NCI_STATUS_NFCEE_TRANSMISSION_ERROR                    0xc2
> > +#define NCI_STATUS_NFCEE_PROTOCOL_ERROR                    
>             0xc3
> >  #define NCI_STATUS_NFCEE_TIMEOUT_ERROR                         0xc4
> 
> You are mixing indentation changes with changes in constants. It would
> be better to put the indentation changes in a another patch.
OK, I'll remove the indentation changes from this patch set (and fix it in a different patch).

> 
> 
> 
> Lauro
> 

Thanks & BR,
Ilan
