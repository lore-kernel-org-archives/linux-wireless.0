Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:25521 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbYLVWkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 17:40:23 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2112886rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 14:40:22 -0800 (PST)
Message-ID: <b6c5339f0812221440h50d92891x621ea58c71e440fa@mail.gmail.com> (sfid-20081222_234027_333777_3000F219)
Date: Mon, 22 Dec 2008 17:40:22 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: sbrown@cortland.com
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: Keir <keirlawson@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <495014BF.1030602@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>
	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>
	 <494A578A.7070803@cortland.com>
	 <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>
	 <494ABA6D.8070002@cortland.com>
	 <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com>
	 <494C0181.8050008@cortland.com>
	 <b6c5339f0812191241q3f2ff8aas5d538568552aca16@mail.gmail.com>
	 <495014BF.1030602@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 5:29 PM, Steve Brown <sbrown@cortland.com> wrote:
> Should I submit a patch for the AR5K_CFG_ADHOC enable/disable bug? With it
> fixed, at least the ap and mesh problems are exposed. Maybe somebody can see
> what's wrong.

Yeah, if you don't mind putting together a patch for that part, that'd be
great.  I doubt anyone would disagree with it.

-- 
Bob Copeland %% www.bobcopeland.com
