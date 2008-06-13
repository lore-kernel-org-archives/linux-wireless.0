Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:12190 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYFMNhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 09:37:05 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3300991waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 06:37:05 -0700 (PDT)
Message-ID: <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com> (sfid-20080613_153710_082687_245B8719)
Date: Fri, 13 Jun 2008 16:37:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwl3945 and WPA
Cc: "Maciek Kaliszewski" <mkalkal@interia.pl>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080613132317.GB5333@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4852658A.4040402@interia.pl> <20080613132317.GB5333@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 4:23 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Jun 13, 2008 at 02:18:18PM +0200, Maciek Kaliszewski wrote:
>> I cannot connect to my WIFI/WPA network using iwl3945 driver.
>
> Any chance that adding a line like this in /etc/modprobe.conf is
> helpful?
>
>        options iwl3945 disable_hw_scan=1
>
> Worth a shot... :-)
>
I would suggest to upgrade supplicant as iwlist is apparently working
> John
> --
> John W. Linville
> linville@tuxdriver.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
