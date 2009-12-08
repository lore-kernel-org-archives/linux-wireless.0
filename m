Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:44260
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935279AbZLHE6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 23:58:39 -0500
Message-ID: <4B1DDB77.6070909@myrealbox.com>
Date: Mon, 07 Dec 2009 23:52:07 -0500
From: Andy Lutomirski <luto@myrealbox.com>
MIME-Version: 1.0
To: lrodriguez@atheros.com
CC: johannes@sipsolutions.ney, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add HT capability parsing for scanning
References: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> This adds HT capability IE parsing for scanning. You will now
> be able to easily review what HT capabilities your AP supports
> with a simple iw scan.
> 

> +	default:
> +		return "Uknown";
> +	}
> +}
> +

Unknown?

--Andy
