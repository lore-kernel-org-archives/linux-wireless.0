Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:19523 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbZCRBYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 21:24:33 -0400
Received: by wf-out-1314.google.com with SMTP id 29so315776wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 18:24:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <af5afd160903171817v6a6ec50al6e933985628e7674@mail.gmail.com>
References: <af5afd160903171817v6a6ec50al6e933985628e7674@mail.gmail.com>
Date: Wed, 18 Mar 2009 12:24:31 +1100
Message-ID: <646765f40903171824t7854e0d4wc2c3de9752ad6370@mail.gmail.com> (sfid-20090318_022437_657629_B762E920)
Subject: Re: compile error.
From: Julian Calaby <julian.calaby@gmail.com>
To: Dennis Kavadas <ipguy@kavadas.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2009 at 12:17, Dennis Kavadas <ipguy@kavadas.org> wrote:
> hi all
>
> i'm currently running a CentOS5 server with kernel version 2.6.18-92.1.22.el5
[snip]
> error: #error Compat-wireless requirement: Linux >= 2,6,21

Your kernel is too old, as it says here, you need a version greater or
equal to 2.6.21.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
