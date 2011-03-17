Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57404.mail.re1.yahoo.com ([66.196.100.55]:29496 "HELO
	web57404.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752714Ab1CQCPo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 22:15:44 -0400
Message-ID: <873100.70856.qm@web57404.mail.re1.yahoo.com>
Date: Wed, 16 Mar 2011 19:15:42 -0700 (PDT)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl 1/1] orinoco: Reduce lock contention by reporting static errors before locking
To: Dave Kilroy <kilroyd@googlemail.com>, Pavel Roskin <proski@gnu.org>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20110316210247.6p9x1s7a8k0ss4wc-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Wed, 3/16/11, Pavel Roskin <proski@gnu.org> wrote:

> From: Pavel Roskin <proski@gnu.org>
> Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl 1/1] orinoco: Reduce lock contention by reporting static errors before locking
> To: "Dave Kilroy" <kilroyd@googlemail.com>
> Cc: "Joe Gunn" <armadefuego@yahoo.com>, orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
> Date: Wednesday, March 16, 2011, 9:02 PM
> Hello!
> 
> >> +       
> return(-EOPNOTSUPP);
>
Sorry. I even knew that. 

 
> "return" is not a function to be written like that. 
> Please use the existing coding style used in the
> kernel.  Also please use checkpatch.pl to catch style
> violations.

Thanks. I'll put that on my list of things to run.

> 
> --Regards,
> Pavel Roskin
> 


      
