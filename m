Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36895 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab2HXXfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 19:35:55 -0400
Received: by dady13 with SMTP id y13so1227070dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 16:35:55 -0700 (PDT)
Date: Fri, 24 Aug 2012 16:36:27 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Deniz Akcal <denizakcal@hotmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"586383@bugs.debian.org" <586383@bugs.debian.org>
Subject: Re: Relatively minor Atheros AR242x wireless card light flickering
 issue with Linux kernel 2.6.32 to 3.5.2 (ath5k driver)
Message-ID: <20120824233627.GA188@mannheim-rule.local> (sfid-20120825_013637_933128_436617DB)
References: <BAY002-W37AC498098AD6D7EBCACA7D7BD0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BAY002-W37AC498098AD6D7EBCACA7D7BD0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Deniz Akcal wrote:

>                       I think the pattern is that when the data
> transfers through the wireless card (such as by going to the
> internet), it activates the flicker when the colour is blue for a
> long time and if it’s already flickering then, it increases the
> rate of the flickering.

Thanks.  Quick questions:

Is this behavior expected or unexpected?  What led you to report it as
a bug?  Is it desirable or undesirable?  Have you been having other
problems with the ath5k driver?

In principle an LED indicating the rx/tx rate could be a nice thing,
but if it is distracting or counterintuitive or related to other
problems then not so much.  Hence the question.

Hope that helps,
Jonathan
