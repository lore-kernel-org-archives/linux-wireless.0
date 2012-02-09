Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:36771 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab2BINm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 08:42:58 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 8D3702C0817E
	for <linux-wireless@vger.kernel.org>; Thu,  9 Feb 2012 14:35:59 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G8Z2l0nmv-eS for <linux-wireless@vger.kernel.org>;
	Thu,  9 Feb 2012 14:35:59 +0100 (CET)
Received: from [192.168.9.222] (unknown [192.168.9.222])
	by aurora.create-net.org (Postfix) with ESMTPSA id EBDFE2C080C6
	for <linux-wireless@vger.kernel.org>; Thu,  9 Feb 2012 14:35:58 +0100 (CET)
Message-ID: <4F33CBBF.5030604@create-net.org> (sfid-20120209_144301_549852_EC06DF29)
Date: Thu, 09 Feb 2012 14:35:59 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 fixed rate packet injection
References: <loom.20120209T131907-783@post.gmane.org>
In-Reply-To: <loom.20120209T131907-783@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm also using packet injection in a custom mesh routing protocol that 
does not rely on the association scheme provided by wifi. At the moment 
I'm using it with madwifi, but I'm very interested in testing it also 
with ath9k and ath5k, so this patch would be very useful to me.

On 02/09/2012 01:38 PM, Lars Bro wrote:
> Hi,
>
> At Jan 20, Sam Leffler posted a patch for enabeling packet injection with the
> rate specified in the radiotap message. Did this ever make its way to the
> release, or was it rejected.
>
> I am investigating the feasibility of using such a function for train-wayside
> communication where it is more important that all wayside radios that receive a
> message forward it to the central. This use case does not comply with the
> association-disassociation scheme, as this is one-to-one.
>
> Lars Bro
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
--------------------------------------------------------
Roberto Riggio, Ph.D.
CREATE-NET
Network & Security Solutions for Pervasive Computing Systems (iNSPIRE)
Senior Researcher
Via alla Cascata 56/D - 38123 Povo Trento (Italy)
e-mail: roberto.riggio@create-net.org
Tel: (+39) 0461 408400 - interno/extension 708
Fax: (+39) 0461 421157
www.create-net.org/~rriggio
--------------------------------------------------------

The information transmitted is intended only for the person or entity to
which it is addressed and may contain confidential and/or privileged
material. Any review, retransmission, dissemination or other use of, or
taking of any action in reliance upon, this information by persons or
entities other than the intended recipient is prohibited according to
the Italian Law 196/2003 of the Legislature. If you received this in
error, please contact the sender and delete the material from any
computer.

Le informazioni contenute in questo messaggio di posta elettronica e nei
file allegati sono da considerarsi strettamente riservate. Il loro
utilizzo e' consentito esclusivamente al destinatario del messaggio, per
le finalita' indicate nel messaggio stesso. Qualora riceveste questo
messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
darcene notizia via e-mail e di procedere alla cancellazione del
messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
od utilizzarlo per finalita' diverse, costituisce comportamento
contrario ai principi dettati dal D. Lgs. 196/2003.
