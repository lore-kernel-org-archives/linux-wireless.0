Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36866 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZEDH7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:59:06 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241423772.8683.8.camel@johannes.local>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 00:58:55 -0700
Message-Id: <1241423935.2899.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >  
> > +static void print_country(unsigned char type, unsigned char len, unsigned char *data)
> > +{
> > +	int i;
> > +
> > +	printf("\tCountry: %.*s data:", 3, data);
> 
> IIRC the third characters there is a space if it's in- and outdoor, it
> might make sense to parse it instead of just printing it?

that explains why I have seen USI here and couldn't make sense of it and
just declared that AP broken :)

Regards

Marcel


