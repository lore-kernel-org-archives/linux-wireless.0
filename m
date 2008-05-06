Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:48598 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYEFHcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 03:32:06 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1047235fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 00:32:04 -0700 (PDT)
Message-ID: <8704f27d0805060032g2312e7dcwc19f382c431e6cd3@mail.gmail.com> (sfid-20080506_093124_576526_1AF77816)
Date: Tue, 6 May 2008 10:32:04 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: dynamic wep with mulitple keys
Cc: "Volker Braun" <vbraun@physics.upenn.edu>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <f6ca9fed0805060022s1f22e09ay5ac20b5ecd08ab9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
	 <f6ca9fed0805060022s1f22e09ay5ac20b5ecd08ab9a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 6, 2008 at 10:22 AM, drago01 <drago01@gmail.com> wrote:
> On Tue, May 6, 2008 at 8:46 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>  > >  I just tried compat-wireless-2008-05-05, which does contain
>  >  >  03dcb07e74a62eec2badb9f6a091790c484f4a6c. No difference:
>  >  >
>  >
>  >  Thanks for trying this.
>  >  Can you try to load the module with swcrypto=1 and try again ?
>  >  This disables the HW encryption acceleration. Trying this will allow
>  >  to make 100% sure that the bug is in iwlwifi. The bug is likely to be
>  >  there, but I think it is worth to make this 100% sure.
>
>  Well it happens for me with iwl3945 which uses swcrypto by default see:
>
>  http://marc.info/?l=linux-wireless&m=120699235803881&w=2
>

Actually, I made quite a lot of changes in security in iwl4965 that
are not in iwl3945 so I think it is worth trying with iwl4965 in SW.
The security code is not the same between 3945 and 4965

-- 
Emmanuel Grumbach
egrumbach@gmail.com
