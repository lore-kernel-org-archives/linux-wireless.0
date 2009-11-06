Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:6831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZKFWYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:24:43 -0500
Received: by fg-out-1718.google.com with SMTP id d23so442719fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257545606.3752.2.camel@localhost.localdomain>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257545606.3752.2.camel@localhost.localdomain>
Date: Fri, 6 Nov 2009 17:24:47 -0500
Message-ID: <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com>
Subject: Re: Changing from Minstrel to PID
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 5:13 PM, Martín Ernesto Barreyro
<barreyromartin@gmail.com> wrote:
>> No, but I wish there were...patches?  Anyone?
>
> Sorry for my ignorance, but how could I send a parameter to a module or
> use a configuration file? could be with sysctl?

You do have to compile them both, but once you do, if you
have debugfs mounted, you can do:

echo 'pid' > /debug/ieee80211/phy0/rc/name

to switch to pid.

-- 
Bob Copeland %% www.bobcopeland.com
