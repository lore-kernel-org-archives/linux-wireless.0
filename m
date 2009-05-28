Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:54558 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZE1R1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 13:27:13 -0400
Received: by gxk10 with SMTP id 10so9337360gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 10:27:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1EC184.7040406@impulze.org>
References: <4A1EAEA7.4070208@impulze.org> <1243528150.20853.7.camel@mj>
	 <4A1EC184.7040406@impulze.org>
Date: Thu, 28 May 2009 13:27:14 -0400
Message-ID: <b6c5339f0905281027t29626cc9i9f7d2c49c571a170@mail.gmail.com>
Subject: Re: ath5k: works only occasionaly
From: Bob Copeland <me@bobcopeland.com>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 12:53 PM, Daniel Mierswa <impulze@impulze.org> wrote:
> On 28.05.2009 18:29, Pavel Roskin wrote:
>> If you can, try connecting to an access point with known good signal to
>> see if the problem is caused by low signal.
> Problem is that I don't have any "known working" APs in public. :-/

Have you used other drivers for comparison purposes?

If it works in madwifi or ndiswrapper/Windows, that would tend to indicate
a driver bug (or missing feature like noise reduction), otherwise you may
have a hardware problem, e.g. with the antenna connection.

-- 
Bob Copeland %% www.bobcopeland.com
