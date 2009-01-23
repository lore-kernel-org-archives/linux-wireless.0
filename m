Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:43983 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZAWS1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:27:50 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4820595rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 10:27:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232733061.6513.2.camel@maxim-laptop>
References: <1232672850.7913.6.camel@maxim-laptop>
	 <1232733061.6513.2.camel@maxim-laptop>
Date: Fri, 23 Jan 2009 13:27:49 -0500
Message-ID: <b6c5339f0901231027j22c9c797x6ad3a29b719eee99@mail.gmail.com> (sfid-20090123_192757_911129_A7DEB937)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work with
	iwl3945
From: Bob Copeland <bcopeland@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 12:51 PM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> On Fri, 2009-01-23 at 03:07 +0200, Maxim Levitsky wrote:
>
>
> I noticed another wierd bug, somehow iwl3945 manages now to break
> suspend to disk (hands on suspend) but not suspend to ram.

Probably related to my mac80211 changes :(  Can you boot with
no_console_suspend=1?

What about direct "echo -n disk > /sys/power/state" ?  I'm not sure what
ubuntu does in the menu, but usually pm-hibernate shuts down interfaces.

-- 
Bob Copeland %% www.bobcopeland.com
