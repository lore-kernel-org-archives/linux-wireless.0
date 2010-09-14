Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33852 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0INRjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:39:25 -0400
Received: by qwh6 with SMTP id 6so4531273qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 10:39:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
Date: Tue, 14 Sep 2010 13:39:24 -0400
Message-ID: <AANLkTik+KjxZSbaShYKq91WN7niZYvtETXbpgDPgj84L@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Steve Glass <stevie.glass@gmail.com>,
	Wee Lum Tan <weelum.tan@nicta.com.au>,
	Marius Portmann <marius@itee.uq.edu.au>,
	Konstanty Bialkowski <konstanty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 1:51 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> as well as 1360 frames which came in with a negative CONTENTION_TIME.
>
> Ignoring the fact that some frames are coming up with a negative
> CONTENTION_TIME (which potentially points to another problem)

How negative are these?  Are you subtracting more for, say, txtime
than you should be?

-- 
Bob Copeland %% www.bobcopeland.com
