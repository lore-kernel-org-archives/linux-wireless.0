Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway15.websitewelcome.com ([67.18.44.26]:60838 "HELO
	gateway15.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752770AbZANSVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 13:21:24 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:32981 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LN9Qm-0001Tk-ET
	for linux-wireless@vger.kernel.org; Wed, 14 Jan 2009 11:21:28 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Re: 'N' Mode and 5GHz, Also WPA2
Date: Wed, 14 Jan 2009 09:21:21 -0800
References: <200901131502.01047.Info@delphi-real-estate.com> <69e28c910901131534g28404687y6bf23bdbbb233b26@mail.gmail.com> <200901131604.22355.Info@delphi-real-estate.com>
In-Reply-To: <200901131604.22355.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901140921.21823.Info@delphi-real-estate.com> (sfid-20090114_192129_594837_086445DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Anyone have any idea why 'n' for 5GHz and WPA2 are not working?

Best,

Bill

On Tuesday 13 January 2009 16:04:22 you wrote:
> 
> On Tuesday 13 January 2009 15:34:47 you wrote:
> > Try checking its FCC ID on the Equipment Authorization page. It has
> > internal photos.
> 
> Thanks, it's here:
> https://fjallfoss.fcc.gov/prod/oet/forms/blobs/retrieve.cgi?attachment_id=979202&native_or_pdf=pdf
> ... looks like an Atheros.  Not sure which one is 5GHz tho...  and I'm not sure how compatible this is with Intel's 4965AGN at 5GHz.
> 
> 
> > > Also I am unable to associate in any mode in any band, with WPA2.  Has anyone got WPA2 working with the iwlagn driver?
> > 
> > Are you running the latest wpa_supplicant?
> 
> The latest one that comes with updated Hardy, 0.6.0+0.5.8-0ubuntu2.  And I'm running an Intrepid kernel on Hardy, so I could get this newer iwlagn driver.
> 
> 
> On Tuesday 13 January 2009 15:39:20 you wrote:
> > Hi Bill.  I use WPA2 with the iwlagn driver on a daily basis, though
> > I've never used it for 5GHz.  If you are using the stock Ubuntu kernel
> > and are having trouble with WPA2 I really suggest using Ubuntu's
> > support resources and/or filing a bug there, the linux wireless
> > mailing list is probably not the right place.  If you are building the
> > wireless-testing kernel and wish to discuss your results, this
> > probably is the right place if you are very specific about your
> > configuration and post useful logs.
> 
> Thanks for being kind.  I've switched to 5GHz exclusively because I stream H.264 using MythTV, and I don't want to pollute the 2.4GHz airwaves for my neighbors. (Also it prevents interference when I'm microwaving dinner, and gives more bandwidth <g>)  But for now I'm limited to 802.11a because 'n' will not associate.
> 
> And WPA2 will not associate under any circumstances for me with the combo 4965AGN and DIR-825.  What's your combo Andrey?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


