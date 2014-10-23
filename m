Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63295 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaJWTzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 15:55:18 -0400
Received: by mail-ob0-f170.google.com with SMTP id nt9so1457303obb.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 12:55:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414093367.254547.182592325.0C3991E4@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
	<1413510814.22769.6.camel@dcbw.local>
	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
	<CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
	<1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
	<CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
	<CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
	<1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
	<CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
	<1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
	<CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
	<54461740.5000903@openwrt.org>
	<1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
	<54461AEF.7040304@openwrt.org>
	<54463CE9.3060400@gmail.com>
	<1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com>
	<CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com>
	<1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com>
	<CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com>
	<1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com>
	<CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
	<1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com>
	<CANUX_P2pJYNhLEMw=iQVe-CSbxqRDqOXL_gUZXxwpmAj2qj=FA@mail.gmail.com>
	<1414085934.228950.182543717.6FA0F16D@webmail.messagingengine.com>
	<CANUX_P0nK9AQEzYGfGFKEU_vVJ9fwOPmjGTCL--zmk+J4uCz4Q@mail.gmail.com>
	<1414093367.254547.182592325.0C3991E4@webmail.messagingengine.com>
Date: Thu, 23 Oct 2014 22:55:18 +0300
Message-ID: <CANUX_P3sTY45ozSL6Rj0PRYgo9aPACdp97HV1SQna3AW5V75xw@mail.gmail.com> (sfid-20141023_215523_087948_1E85062A)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a113d2bf299f29405061c7180
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a113d2bf299f29405061c7180
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 10:42 PM, Lauren=C8=9Biu Nicola <lnicola@dend.ro> w=
rote:
> Doesn't seem to help https://bpaste.net/show/68e1a6b33689.

ok - let me re-add the logs...


>
> Laurentiu
>
> On Thu, Oct 23, 2014, at 22:28, Emmanuel Grumbach wrote:
>> On Thu, Oct 23, 2014 at 8:38 PM, Lauren=C8=9Biu Nicola <lnicola@dend.ro>
>> wrote:
>> > Okay. I'm running 3.17.1, so the line numbers might not be the ones
>> > you're expecting:
>> >
>> > patching file net/mac80211/mlme.c
>> > Hunk #1 succeeded at 128 (offset -1 lines).
>> > Hunk #2 succeeded at 137 (offset -1 lines).
>> > Hunk #3 succeeded at 1875 (offset -209 lines).
>> > Hunk #4 succeeded at 1886 (offset -207 lines).
>> > Hunk #5 succeeded at 1908 (offset -207 lines).
>> > Hunk #6 succeeded at 1924 (offset -244 lines).
>> >
>> > dmesg output is at https://bpaste.net/show/649277aaada8 .
>>
>> can you please test the patch attached?
>>
>> (remove the previous one first please)
>>
>> >
>> > Laurentiu
>> >
>> > On Thu, Oct 23, 2014, at 19:46, Emmanuel Grumbach wrote:
>> >> On Thu, Oct 23, 2014 at 7:02 PM, Lauren=C8=9Biu Nicola <lnicola@dend.=
ro>
>> >> wrote:
>> >> > Sorry, but I only saw a two-line change [1] to
>> >> > `ieee80211_rx_mgmt_beacon` (which already had a log message). Am I
>> >> > missing something?
>> >> >
>> >> > [1] http://www.spinics.net/lists/linux-wireless/msg128340.html
>> >> >
>> >>
>> >> No - you are not. I did miss something...I forgot to attach the patch=
.
>> >> Here you go.
>> >>
>> >> > Laurentiu
>> >> >
>> >> > On Thu, Oct 23, 2014, at 11:07, Emmanuel Grumbach wrote:
>> >> >> On Thu, Oct 23, 2014 at 10:30 AM, Lauren=C8=9Biu Nicola <lnicola@d=
end.ro>
>> >> >> wrote:
>> >> >> > I did; the card still gets disconnected and the message doesn't =
show up
>> >> >> > in dmesg.
>> >> >> >
>> >> >>
>> >> >> You had *none* of the many prints I added in the log?
>> >> >>
>> >> >> That seems really weird...
>> >> >>
>> >> >> > Laurentiu
>> >> >> >
>> >> >> > On Thu, Oct 23, 2014, at 08:21, Emmanuel Grumbach wrote:
>> >> >> >> On Thu, Oct 23, 2014 at 12:53 AM, Lauren=C8=9Biu Nicola <lnicol=
a@dend.ro>
>> >> >> >> wrote:
>> >> >> >> > Nope. It seems that code doesn't get executed when my issue o=
ccurs (or
>> >> >> >> > in my five or ten minutes of uptime). I've seen
>> >> >> >> > `ieee80211_reset_ap_probe` get called by `ieee80211_rx_mgmt_p=
robe_resp`,
>> >> >> >> > but (if I'm not wrong) not on every disconnect.
>> >> >> >> >
>> >> >> >> > And as far as I can tell, force_cam is set to true.
>> >> >> >>
>> >> >> >> Can you please try with the patch attached and send the logs?
>> >> >> >> I again need MAC80211_MLME_DEBUG.
>> >> >> >>
>> >> >> >> Thanks.
>> >> >> >>
>> >> >> >> >
>> >> >> >> > Laurentiu
>> >> >> >> >
>> >> >> >> > On Wed, Oct 22, 2014, at 12:10, Emmanuel Grumbach wrote:
>> >> >> >> >> On Tue, Oct 21, 2014 at 10:56 PM, Lauren=C8=9Biu Nicola <lni=
cola@dend.ro>
>> >> >> >> >> wrote:
>> >> >> >> >> > Yep! `scb_timeout` is 60 on my router.
>> >> >> >> >> >
>> >> >> >> >> > On Tue, Oct 21, 2014, at 14:00, poma wrote:
>> >> >> >> >> >> On 21.10.2014 10:35, Felix Fietkau wrote:
>> >> >> >> >> >> > On 2014-10-21 10:23, Lauren=C8=9Biu Nicola wrote:
>> >> >> >> >> >> >> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
>> >> >> >> >> >> > This is a Broadcom based device, so it should behave in=
 the same way as
>> >> >> >> >> >> > other APs/Routers running the Broadcom drivers.
>> >> >> >> >> >> > The driver should only send Reason 7 when receiving a P=
S-Poll, BlockAck,
>> >> >> >> >> >> > BlockAckReq or Action frame from a station that's not a=
ssociated, so
>> >> >> >> >> >> > probably it has already kicked out your iwlwifi client =
earlier. Not sure
>> >> >> >> >> >> > why that doesn't show up in the log though.
>> >> >> >> >> >> >
>> >> >> >> >> >>
>> >> >> >> >> >> Whether this might refer to the Station Control Block Tim=
eout value
>> >> >> >> >> >>
>> >> >> >> >> >> http://www.dd-wrt.com/wiki/index.php/Wl#scb_timeout
>> >> >> >> >> >> ...
>> >> >> >> >> >> scb_timeout
>> >> >> >> >> >>
>> >> >> >> >> >> AP only: inactivity timeout value for authenticated stas
>> >> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >> Actually, mac80211 should be probing the AP every 30 seconds=
 but a
>> >> >> >> >> beacon might abort the probe...
>> >> >> >> >> Can you try something like this:
>> >> >> >> >>
>> >> >> >> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> >> >> >> >> index 75df184..c9db7cf 100644
>> >> >> >> >> --- a/net/mac80211/mlme.c
>> >> >> >> >> +++ b/net/mac80211/mlme.c
>> >> >> >> >> @@ -3295,7 +3295,8 @@ static void ieee80211_rx_mgmt_beacon(s=
truct
>> >> >> >> >> ieee80211_sub_if_data *sdata,
>> >> >> >> >>         if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
>> >> >> >> >>                 mlme_dbg_ratelimited(sdata,
>> >> >> >> >>                                      "cancelling AP probe du=
e to a
>> >> >> >> >> received beacon\n");
>> >> >> >> >> -               ieee80211_reset_ap_probe(sdata);
>> >> >> >> >> +               pr_err("Not cancelling the probe to make sur=
e the AP
>> >> >> >> >> hears us from time to time\n");
>> >> >> >> >> +               //ieee80211_reset_ap_probe(sdata);
>> >> >> >> >>         }
>> >> >> >> >>
>> >> >> >> >>         /*
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >> >>
>> >> >> >> >> >> poma
>> >> >> >> >> >>
>> >> >> >> >> >>
>> >> >> >> >> >> --
>> >> >> >> >> >> To unsubscribe from this list: send the line "unsubscribe=
 linux-wireless"
>> >> >> >> >> >> in
>> >> >> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-=
info.html
>> >> >> >> >> --
>> >> >> >> >> To unsubscribe from this list: send the line "unsubscribe li=
nux-wireless"
>> >> >> >> >> in
>> >> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
>> >> >> >> --
>> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux=
-wireless"
>> >> >> >> in
>> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-wi=
reless"
>> >> >> in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> Email had 1 attachment:
>> >> + PROBE.patch
>> >>   3k (application/octet-stream)
>> Email had 1 attachment:
>> + a.patch
>>   3k (application/octet-stream)

--001a113d2bf299f29405061c7180
Content-Type: application/octet-stream; name="a.patch"
Content-Disposition: attachment; filename="a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1mj4d9r0

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmlu
ZGV4IDJkZTg4NzAuLjQ1N2Y1MjA3IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvbWxtZS5jCisr
KyBiL25ldC9tYWM4MDIxMS9tbG1lLmMKQEAgLTEyOSw2ICsxMjksNyBAQCB2b2lkIGllZWU4MDIx
MV9zdGFfcmVzZXRfY29ubl9tb25pdG9yKHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNk
YXRhKQogewogCXN0cnVjdCBpZWVlODAyMTFfaWZfbWFuYWdlZCAqaWZtZ2QgPSAmc2RhdGEtPnUu
bWdkOwogCisJbWxtZV9kYmcoc2RhdGEsICIlczolZFxuIiwgX19mdW5jX18sIF9fTElORV9fKTsK
IAlpZiAodW5saWtlbHkoIXNkYXRhLT51Lm1nZC5hc3NvY2lhdGVkKSkKIAkJcmV0dXJuOwogCkBA
IC0xMzcsNiArMTM4LDkgQEAgdm9pZCBpZWVlODAyMTFfc3RhX3Jlc2V0X2Nvbm5fbW9uaXRvcihz
dHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSkKIAlpZiAoc2RhdGEtPmxvY2FsLT5o
dy5mbGFncyAmIElFRUU4MDIxMV9IV19DT05ORUNUSU9OX01PTklUT1IpCiAJCXJldHVybjsKIAor
CW1sbWVfZGJnKHNkYXRhLCAiJXM6JWRcbiIsIF9fZnVuY19fLCBfX0xJTkVfXyk7CisKKwlkdW1w
X3N0YWNrKCk7CiAJbW9kX3RpbWVyKCZzZGF0YS0+dS5tZ2QuY29ubl9tb25fdGltZXIsCiAJCSAg
cm91bmRfamlmZmllc191cChqaWZmaWVzICsgSUVFRTgwMjExX0NPTk5FQ1RJT05fSURMRV9USU1F
KSk7CiB9CkBAIC0xOTMzLDI4ICsxOTM3LDEzIEBAIHN0YXRpYyB2b2lkIGllZWU4MDIxMV9zZXRf
ZGlzYXNzb2Moc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEsCiAJc2RhdGEtPmVu
Y3J5cHRfaGVhZHJvb20gPSBJRUVFODAyMTFfRU5DUllQVF9IRUFEUk9PTTsKIH0KIAotdm9pZCBp
ZWVlODAyMTFfc3RhX3J4X25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0
YSwKLQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkcikKLXsKLQkvKgotCSAqIFdlIGNh
biBwb3N0cG9uZSB0aGUgbWdkLnRpbWVyIHdoZW5ldmVyIHJlY2VpdmluZyB1bmljYXN0IGZyYW1l
cwotCSAqIGZyb20gQVAgYmVjYXVzZSB3ZSBrbm93IHRoYXQgdGhlIGNvbm5lY3Rpb24gaXMgd29y
a2luZyBib3RoIHdheXMKLQkgKiBhdCB0aGF0IHRpbWUuIEJ1dCBtdWx0aWNhc3QgZnJhbWVzIChh
bmQgaGVuY2UgYWxzbyBiZWFjb25zKSBtdXN0Ci0JICogYmUgaWdub3JlZCBoZXJlLCBiZWNhdXNl
IHdlIG5lZWQgdG8gdHJpZ2dlciB0aGUgdGltZXIgZHVyaW5nCi0JICogZGF0YSBpZGxlIHBlcmlv
ZHMgZm9yIHNlbmRpbmcgdGhlIHBlcmlvZGljIHByb2JlIHJlcXVlc3QgdG8gdGhlCi0JICogQVAg
d2UncmUgY29ubmVjdGVkIHRvLgotCSAqLwotCWlmIChpc19tdWx0aWNhc3RfZXRoZXJfYWRkciho
ZHItPmFkZHIxKSkKLQkJcmV0dXJuOwotCi0JaWVlZTgwMjExX3N0YV9yZXNldF9jb25uX21vbml0
b3Ioc2RhdGEpOwotfQotCiBzdGF0aWMgdm9pZCBpZWVlODAyMTFfcmVzZXRfYXBfcHJvYmUoc3Ry
dWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEpCiB7CiAJc3RydWN0IGllZWU4MDIxMV9p
Zl9tYW5hZ2VkICppZm1nZCA9ICZzZGF0YS0+dS5tZ2Q7CiAJc3RydWN0IGllZWU4MDIxMV9sb2Nh
bCAqbG9jYWwgPSBzZGF0YS0+bG9jYWw7CiAKKwltbG1lX2RiZyhzZGF0YSwgIiVzOiVkIHN0YXJ0
XG4iLCBfX2Z1bmNfXywgX19MSU5FX18pOworCiAJbXV0ZXhfbG9jaygmbG9jYWwtPm10eCk7CiAJ
aWYgKCEoaWZtZ2QtPmZsYWdzICYgSUVFRTgwMjExX1NUQV9DT05ORUNUSU9OX1BPTEwpKQogCQln
b3RvIG91dDsKQEAgLTE5NzUsMTMgKzE5NjQsMjcgQEAgc3RhdGljIHZvaWQgaWVlZTgwMjExX3Jl
c2V0X2FwX3Byb2JlKHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhKQogCSAqLwog
CWllZWU4MDIxMV9zdGFfcmVzZXRfYmVhY29uX21vbml0b3Ioc2RhdGEpOwogCi0JbW9kX3RpbWVy
KCZpZm1nZC0+Y29ubl9tb25fdGltZXIsCi0JCSAgcm91bmRfamlmZmllc191cChqaWZmaWVzICsK
LQkJCQkgICBJRUVFODAyMTFfQ09OTkVDVElPTl9JRExFX1RJTUUpKTsKIG91dDoKIAltdXRleF91
bmxvY2soJmxvY2FsLT5tdHgpOwogfQogCit2b2lkIGllZWU4MDIxMV9zdGFfcnhfbm90aWZ5KHN0
cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhLAorCQkJICAgICBzdHJ1Y3QgaWVlZTgw
MjExX2hkciAqaGRyKQoreworCS8qCisJICogV2UgY2FuIHBvc3Rwb25lIHRoZSBtZ2QudGltZXIg
d2hlbmV2ZXIgcmVjZWl2aW5nIHVuaWNhc3QgZnJhbWVzCisJICogZnJvbSBBUCBiZWNhdXNlIHdl
IGtub3cgdGhhdCB0aGUgY29ubmVjdGlvbiBpcyB3b3JraW5nIGJvdGggd2F5cworCSAqIGF0IHRo
YXQgdGltZS4gQnV0IG11bHRpY2FzdCBmcmFtZXMgKGFuZCBoZW5jZSBhbHNvIGJlYWNvbnMpIG11
c3QKKwkgKiBiZSBpZ25vcmVkIGhlcmUsIGJlY2F1c2Ugd2UgbmVlZCB0byB0cmlnZ2VyIHRoZSB0
aW1lciBkdXJpbmcKKwkgKiBkYXRhIGlkbGUgcGVyaW9kcyBmb3Igc2VuZGluZyB0aGUgcGVyaW9k
aWMgcHJvYmUgcmVxdWVzdCB0byB0aGUKKwkgKiBBUCB3ZSdyZSBjb25uZWN0ZWQgdG8uCisJICov
CisJaWYgKGlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpKQorCQlyZXR1cm47CisK
KwlpZWVlODAyMTFfcmVzZXRfYXBfcHJvYmUoc2RhdGEpOworfQorCiB2b2lkIGllZWU4MDIxMV9z
dGFfdHhfbm90aWZ5KHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhLAogCQkJICAg
ICBzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyLCBib29sIGFjaykKIHsKQEAgLTE5OTAsMTYgKzE5
OTMsMjAgQEAgdm9pZCBpZWVlODAyMTFfc3RhX3R4X25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX3N1
Yl9pZl9kYXRhICpzZGF0YSwKIAogCWlmIChpZWVlODAyMTFfaXNfbnVsbGZ1bmMoaGRyLT5mcmFt
ZV9jb250cm9sKSAmJgogCSAgICBzZGF0YS0+dS5tZ2QucHJvYmVfc2VuZF9jb3VudCA+IDApIHsK
LQkJaWYgKGFjaykKKwkJaWYgKGFjaykgeworCQkJbWxtZV9kYmcoc2RhdGEsICIlczolZCBSZXNl
dGluZyBjb25uIG1vblxuIiwgX19mdW5jX18sIF9fTElORV9fKTsKIAkJCWllZWU4MDIxMV9zdGFf
cmVzZXRfY29ubl9tb25pdG9yKHNkYXRhKTsKKwkJfQogCQllbHNlCiAJCQlzZGF0YS0+dS5tZ2Qu
bnVsbGZ1bmNfZmFpbGVkID0gdHJ1ZTsKIAkJaWVlZTgwMjExX3F1ZXVlX3dvcmsoJnNkYXRhLT5s
b2NhbC0+aHcsICZzZGF0YS0+d29yayk7CiAJCXJldHVybjsKIAl9CiAKLQlpZiAoYWNrKQorCWlm
IChhY2spIHsKKwkJbWxtZV9kYmcoc2RhdGEsICIlczolZCBSZXNldGluZyBjb25uIG1vblxuIiwg
X19mdW5jX18sIF9fTElORV9fKTsKIAkJaWVlZTgwMjExX3N0YV9yZXNldF9jb25uX21vbml0b3Io
c2RhdGEpOworCX0KIH0KIAogc3RhdGljIHZvaWQgaWVlZTgwMjExX21nZF9wcm9iZV9hcF9zZW5k
KHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhKQpAQCAtMzY4Miw2ICszNjg5LDcg
QEAgc3RhdGljIHZvaWQgaWVlZTgwMjExX3N0YV9jb25uX21vbl90aW1lcih1bnNpZ25lZCBsb25n
IGRhdGEpCiAJCShzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICopIGRhdGE7CiAJc3RydWN0
IGllZWU4MDIxMV9pZl9tYW5hZ2VkICppZm1nZCA9ICZzZGF0YS0+dS5tZ2Q7CiAJc3RydWN0IGll
ZWU4MDIxMV9sb2NhbCAqbG9jYWwgPSBzZGF0YS0+bG9jYWw7CisJbWxtZV9kYmcoc2RhdGEsICIl
czolZFxuIiwgX19mdW5jX18sIF9fTElORV9fKTsKIAogCWlmIChsb2NhbC0+cXVpZXNjaW5nKQog
CQlyZXR1cm47CkBAIC0zNjg5LDYgKzM2OTcsNyBAQCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfc3Rh
X2Nvbm5fbW9uX3RpbWVyKHVuc2lnbmVkIGxvbmcgZGF0YSkKIAlpZiAoc2RhdGEtPnZpZi5jc2Ff
YWN0aXZlKQogCQlyZXR1cm47CiAKKwltbG1lX2RiZyhzZGF0YSwgIiVzOiVkICBLSUNLSU5HIFBS
T0JFXG4iLCBfX2Z1bmNfXywgX19MSU5FX18pOwogCWllZWU4MDIxMV9xdWV1ZV93b3JrKCZsb2Nh
bC0+aHcsICZpZm1nZC0+bW9uaXRvcl93b3JrKTsKIH0KIApAQCAtMzY5OCw2ICszNzA3LDcgQEAg
c3RhdGljIHZvaWQgaWVlZTgwMjExX3N0YV9tb25pdG9yX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCQljb250YWluZXJfb2Yod29yaywgc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0
YSwKIAkJCSAgICAgdS5tZ2QubW9uaXRvcl93b3JrKTsKIAorCW1sbWVfZGJnKHNkYXRhLCAiJXM6
JWRcbiIsIF9fZnVuY19fLCBfX0xJTkVfXyk7CiAJaWVlZTgwMjExX21nZF9wcm9iZV9hcChzZGF0
YSwgZmFsc2UpOwogfQogCg==
--001a113d2bf299f29405061c7180--
