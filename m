Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:36479 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbYEUKXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 06:23:55 -0400
From: Henning Rogge <rogge@fgan.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Get adhoc signal strength and bandwith from userspace
Date: Wed, 21 May 2008 12:23:53 +0200
References: <200805211106.42682.rogge@fgan.de> <200805211213.01980.br1@einfach.org>
In-Reply-To: <200805211213.01980.br1@einfach.org>
Cc: bruno randolf <br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200805211223.53710.rogge@fgan.de> (sfid-20080521_122416_954053_E0C77791)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 21 Mai 2008 12:13:01 schrieben Sie:
> On Wednesday 21 May 2008 11:06:42 Henning Rogge wrote:
> i don't think that exists yet, but i'm interrested in something like =
that
> too, and i guess most people involvend in mesh networking protocols a=
nd
> metrics.
Exactly... a generic interface to this values would be great.

> however i think "average signal quality" and "thruput" is a bit much =
to ask
> for (average over which period of time? weighted average? moving aver=
age?)
> - how about signal/noise of the last packet, physical rate and bytes =
in/out
> instead? you can average and calculate bandwidth in userspace.
At least the bandwith should be directly available from the bandwith=20
algorithm. Signal strength might be a little bit more tricky, but a=20
value "average signal strength within the last 100 ms/1s" would be much=
=20
easier to use than to parse a value for each incoming package.

Henning


*************************************************
Diplom Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
